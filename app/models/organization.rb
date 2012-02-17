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
                       params[:api_key],
                       params[:package_name],
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
                  params[:organization_web])
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
