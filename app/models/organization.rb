class Organization

  PRIMARY_KEY = "cartodb_id"

  ATTRIBUTES = [
                "contact_name",
                "email",
                "telephone",
                "is_validated",
                "organization_country",
                "organization_guid",
                "organization_name",
                "organization_type_id",
                "organization_web",
                "package_name",
                "created_at",
                "updated_at",
                "api_key",
               ]
  ATTRS_WITH_KEY = ATTRIBUTES.push PRIMARY_KEY

  # find Organization by id
  #----------------------------------------------------------------------

  def self.find(id)
    sql="SELECT #{ATTRS_WITH_KEY.join(',')}
    FROM organizations WHERE cartodb_id = ?"
    result = Oar::execute_query(sql, id)
    result.rows.first
  end

  def self.by_email(email)
    sql="SELECT #{ATTRS_WITH_KEY.join(',')}
         FROM organizations WHERE email='?'"
    result = Oar::execute_query(sql, email)
    result.rows.first
  end

  def self.by_email_and_password(email, password)
    sql="SELECT #{ATTRS_WITH_KEY.join(',')}
         FROM organizations WHERE email='?' AND password=md5('?')"
    result = Oar::execute_query(sql, Oar::quote_string(email), Oar::quote_string(password))
    result.rows.first
  end

  def self.update(id, params)
    sql="UPDATE organizations SET organization_guid ='?',
          password = md5('?'), contact_name= '?', telephone = '?',
          organization_name = '?', organization_type_id ='?',
          organization_country = '?', organization_web ='?',
          api_key = '?', package_name = '?'
          where cartodb_id = ?"
    Oar::execute_query(sql, params[:organization_guid],
                       params[:password],
                       params[:contact_name],
                       params[:telephone],
                       params[:organization_name],
                       params[:organization_type_id],
                       params[:organization_country],
                       params[:organization_web],
                       params[:api_key].strip,
                       params[:package_name].strip,
                       id)
  end

  def self.create(params)
    sql="INSERT INTO organizations(organization_guid, email, password, contact_name, telephone, organization_name,
         organization_type_id, organization_country, organization_web, is_validated)
         VALUES('?','?',md5('?'),'?','?',
         '?','?',
         '?','?', 'false')"
    Oar::execute_query(sql, params[:organization_guid],
                  params[:email],
                  params[:password],
                  params[:contact_name],
                  params[:telephone],
                  params[:organization_name],
                  params[:organization_type_id],
                  params[:organization_country],
                  params[:organization_web],
                  params[:api_key].strip,
                  params[:package_name].strip)
    # return the recently created organization
    Organization.by_email(params[:email])
  end


  # return all the projects and markers for a given organization
  #----------------------------------------------------------------------

  def self.dashboard_projects(organization_id)
    sql = <<-SQL
     SELECT *
     FROM
       (SELECT p.cartodb_id,
            p.title,
            array_agg(ps.sector_id) AS sectors,
            (p.budget || p.budget_currency) AS budget,
            p.start_date,
            p.end_date
       FROM projects p
       LEFT OUTER JOIN project_sectors ps ON ps.project_id = p.cartodb_id
       WHERE p.organization_id = ?
       GROUP BY p.cartodb_id,
              p.title,
              p.budget,
              p.budget_currency,
              p.start_date,
              p.end_date) as tableA
     LEFT OUTER JOIN
       (SELECT p.cartodb_id, array_agg((ST_X(rg.the_geom) || ' ' || ST_Y(rg.the_geom))) as project_markers
              FROM projects p
              LEFT OUTER JOIN reverse_geo rg ON rg.project_id = p.cartodb_id
              WHERE p.organization_id = ?
              GROUP BY p.cartodb_id) as tableB
     ON tableA.cartodb_id = tableB.cartodb_id
    SQL

    Oar::execute_query(sql, organization_id, organization_id)
  end

  # IATI REGISTRY
  #======================================================================

  def self.iati_connection
    # if the app is running in development mode, it connects to the
    # iati's test server
    Faraday.new(:url => IATI_API_BASE_URL) do |builder|
      builder.use Faraday::Request::UrlEncoded
      builder.use Faraday::Response::Logger
      builder.use Faraday::Adapter::NetHttp
    end
  end

  # get details of a dataset
  # if the response.status == 404 the response.body is "Not found"
  # if the response.status == 200 the response body is a hash with the data
  def self.iati_get(dataset_name)
    conn = Organization.iati_connection
    conn.get "/api/rest/dataset/#{dataset_name}"
  end

  # publish the organization datasets
  # organization == hash with all the organization data
  def self.iati_publish_all(organization)
    activity_response = Organization.iati_publish(organization, "activity")
    organization_response = Organization.iati_publish(organization, "organization")
    response = {
      activity_response: activity_response,
      organization_response: organization_response
    }
    response
  end

  def self.iati_publish(organization, filetype)
    # the dataset name is automatically generated based on the publisher name
    dataset_name = "#{organization[:package_name]}-#{filetype}"
    # check if the dataset is already published
    resp1 = Organization.iati_get dataset_name
    if resp1.status == 200
      # already published, update the dataset
      response = Organization.iati_dataset_update(organization, filetype)
    else
      # not published, create the dataset
      response = Organization.iati_dataset_create(organization, filetype)
    end
    response
  end

  def self.iati_dataset_create(organization, filetype)
    conn = Organization.iati_connection
    conn.post do |req|
      req.url '/api/rest/dataset'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = organization[:api_key]
      req.body = self.iati_json(organization, filetype)
    end
  end

  def self.iati_dataset_update(organization, filetype)
    conn = Organization.iati_connection
    dataset_name = "#{organization[:package_name]}-#{filetype}"
    conn.post do |req|
      req.url "/api/rest/dataset/#{dataset_name}"
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = organization[:api_key]
      req.body = self.iati_json(organization, filetype)
    end
  end

  def self.iati_json(organization, filetype)
    if filetype == "activity"
      url = "http://openaidregister.org/organizations/#{organization[:cartodb_id]}/projects.xml"
    else # organization
      url = "http://openaidregister.org/organizations/#{organization[:cartodb_id]}.xml"
    end
    {
      name: "#{organization[:package_name]}-#{filetype}",
      title: "#{organization[:package_name]} #{filetype}",
      author_email: organization[:email],
      resources: [ {
                     url: url,
                     format: "IATI-XML"
                   } ],
      extras: {
        filetype: filetype
      },
      groups: [ organization[:package_name] ]
    }.to_json
  end

  # response == the response returned in iati_publish_all
  def self.iati_combined_response_message(response)
    status = response.values.collect{|v| v.status }.max
    Organization.iati_status_message(status)
  end

  def self.iati_status_message(status)
    case status
    when 200 # File created the first time
      "Congrats! Your data was sucesfully published in the IATI Registry."
    when 201 # File updated
      "Congrats! Your data was sucesfully updated in IATI Registry."
    when 403 # Authentication error
      "Ooops! It seems there was an error while inserting the data in IATI Registry. Can you check if your API-Key is correct? If this error persists, contact us"
    when 404 # returned when the publisher is wrong)
      "Ooops! It seems there was an error while inserting the data in IATI Registry. Can you check if your Publisher ID is correct? If this error persists, contact us"
    else # Any other error
      "Ooops! There was an error while inserting the data in IATI Registry. Try it again or contact us if this error persists"
    end
  end

  # VALIDATE SOME PARAMS
  # and return the errors array
  #======================================================================

  def self.validate(params, errors=[])
    # password length Validation.
    if params[:password].empty?
      errors.push("Password is empty")
    elsif params[:password].length < 3
      errors.push("Insufficient password's length")
    end

    # password_confirm Validation.
    if params[:password_confirm].empty?
      errors.push("You need to repeat the password")
    else
      unless params[:password_confirm].eql?(params[:password])
        errors.push("Password's don't match")
      end
    end

    # Name length Validation.
    if params[:contact_name].empty?
      errors.push("Your name is empty")
    elsif params[:contact_name].length < 3
      errors.push("Please enter name and surname. It should be longer than 2 characters")
    end

    # Phone Validation.
    # if params[:telephone].length < 4
    #   errors.push("Your telephone is empty or too short")
    # end

    # Organization length Validation.
    if params[:organization_name].empty?
      errors.push("Your organization's name is empty")
    elsif params[:organization_name].length < 3
      errors.push("The organization name should be longer than 2 characters")
    end

    # Organization's type Validation.
    if params[:organization_type_id].eql?("")
      errors.push("Please select your organization's type")
    end

    # Organization's country Validation.
    if params[:organization_country].eql?("")
      errors.push("Please select your organization's country")
    end

    # api_key validation
    if params[:api_key].strip.present? && !params[:api_key].strip.match(/\A[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}\z/)
      errors.push("The format of your IATI api key is invalid")
    end

    # publisher name
    if params[:package_name].strip.present? && !params[:package_name].strip.match(/^\w*$/)
      errors.push("The format of your publisher id is invalid")
    end

    errors
  end

  # MORE VALIDATIONS
  #----------------------------------------------------------------------

  def self.validate_email_and_conditions(params, errors=[])
    if params[:email].blank?
      errors.push("The email is empty")
    else
      existing_org = Organization.by_email(params[:email])
      if existing_org
        errors.push("This email already exists")
      elsif !Oar::match_email(params[:email])
        errors.push("The format of the email is wrong")
      end
    end

    if params[:conditions].blank?
      errors.push("Please accept the conditions and terms")
    end
    errors
  end

end
