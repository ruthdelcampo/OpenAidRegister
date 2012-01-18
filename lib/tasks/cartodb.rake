namespace :oar do

  namespace :cartodb do

    desc "Create the OpenAidRegister database tables in cartodb"
    task :create_tables => :environment do

      organizations_scm = [
        { name: 'api_key',              type: 'text'     },
        { name: 'contact_name',         type: 'text'     },
        { name: 'email',                type: 'text'     },
        { name: 'is_valid_publish',     type: 'boolean'  },
        { name: 'is_validated',         type: 'boolean'  },
        { name: 'organization_country', type: 'text'     },
        { name: 'organization_guid',    type: 'text'     },
        { name: 'organization_name',    type: 'text'     },
        { name: 'organization_type_id', type: 'numeric'  },
        { name: 'organization_web',     type: 'text'     },
        { name: 'package_name',         type: 'text'     },
        { name: 'password',             type: 'text'     },
        { name: 'random_token',         type: 'text'     },
        { name: 'telephone',            type: 'text'     },
        { name: 'the_geom_str',         type: 'text'     }
      ]

      project_partnerorganizations_scm = [
        { name: 'other_org_name',       type: 'text'     },
        { name: 'other_org_role',       type: 'text'     },
        { name: 'project_id',           type: 'numeric'  },
        { name: 'the_geom_str',         type: 'text'     }
      ]

      project_sectors_scm = [
        { name: 'project_id',           type: 'numeric'  },
        { name: 'sector_id',            type: 'numeric'  },
        { name: 'the_geom_str',         type: 'text'     }
      ]

      reverse_geo_scm = [
        { name: 'adm1',                 type: 'text'     },
        { name: 'adm2',                 type: 'text'     },
        { name: 'country',              type: 'text'     },
        { name: 'country_extended',     type: 'text'     },
        { name: 'level_detail',         type: 'text'     },
        { name: 'project_id',           type: 'numeric'  },
        { name: 'the_geom',             type: 'geometry' }
      ]

      project_relateddocs_scm = [
        { name: 'doc_type',             type: 'text'     },
        { name: 'doc_url',              type: 'text'     },
        { name: 'project_id',           type: 'numeric'  },
        { name: 'the_geom_str',         type: 'text'     }
      ]

      projects_scm = [
        { name: 'aid_type',             type: 'text'     },
        { name: 'budget',               type: 'text'     },
        { name: 'budget_currency',      type: 'text'     },
        { name: 'collaboration_type',   type: 'text'     },
        { name: 'contact_email',        type: 'text'     },
        { name: 'contact_name',         type: 'text'     },
        { name: 'description',          type: 'text'     },
        { name: 'end_date',             type: 'date'     },
        { name: 'finance_type',         type: 'text'     },
        { name: 'flow_type',            type: 'text'     },
        { name: 'language',             type: 'text'     },
        { name: 'org_role',             type: 'text'     },
        { name: 'organization_id',      type: 'numeric'  },
        { name: 'program_guid',         type: 'text'     },
        { name: 'project_guid',         type: 'text'     },
        { name: 'result_description',   type: 'text'     },
        { name: 'result_title',         type: 'text'     },
        { name: 'start_date',           type: 'date'     },
        { name: 'tied_status',          type: 'text'     },
        { name: 'title',                type: 'text'     },
        { name: 'website',              type: 'text'     },
        { name: 'the_geom',             type: 'geometry' }
      ]

      project_transactions_scm = [
        { name: 'project_id',              type: 'numeric' },
        { name: 'provider_activity_id',    type: 'text'    },
        { name: 'provider_id',             type: 'text'    },
        { name: 'provider_name',           type: 'text'    },
        { name: 'receiver_activity_id',    type: 'text'    },
        { name: 'receiver_id',             type: 'text'    },
        { name: 'receiver_name',           type: 'text'    },
        { name: 'the_geom_str',            type: 'text'    },
        { name: 'transaction_currency',    type: 'text'    },
        { name: 'transaction_date',        type: 'date'    },
        { name: 'transaction_description', type: 'text'    },
        { name: 'transaction_type',        type: 'text'    },
        { name: 'transaction_value',       type: 'text'    }
      ]

      sectors_scm = [
        { name: 'name',         type: 'text'    },
        { name: 'sector_code',  type: 'numeric' },
        { name: 'the_geom_str', type: 'text'    }
      ]

      tables = [
       'organizations',
       'project_partnerorganizations',
       'project_sectors',
       'reverse_geo',
       'project_relateddocs',
       'projects',
       'project_transactions',
       'sectors'
      ]

      tables.each do |table_name|
        puts "Creating #{table_name} table..."
        CartoDB::Connection.create_table table_name, eval("#{table_name}_scm"), 'POINT'
      end

    end


    desc "Delete all the OpenAidRegister tables from cartodb"
    task :drop_tables => :environment do
      if CartoDB::Settings["host"].match /openaiddev/
        puts("You can't delete the staging database")
        exit
      else

        puts <<-END
#----------------------------------------------------------------------
# WARNING! You are in the #{Rails.env.upcase} environment and are running a
# Rake task that will DESTROY your #{Rails.env.upcase} databases.
#
# If you know what you are doing go ahead and respond Yes to the next
# question.
#----------------------------------------------------------------------

Are you sure? (Yes|No) [No]
END

        confirmation = STDIN.gets.chomp.downcase
        puts('Quitting.') || exit unless confirmation == 'yes'
        puts "Are you completely sure? (Yay|No) [No]"
        final_confirmation = STDIN.gets.chomp.downcase
        puts('Okay, okay, quitting.') || exit unless final_confirmation == 'yay'

        puts "DELETING ALL THE DATABASES NOW"
        response = CartoDB::Connection.tables
        if response[:total_entries] > 0
          response[:tables].each do |table|
            CartoDB::Connection.drop_table table[:name]
          end
        end
      end
    end

  end
end
