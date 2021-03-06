class UserRolesDatatable < AjaxDatatablesRails::Base

  def_delegators :@view, :link_to, :truncate, :role_user_path, :role_users_path, :policy

  def view_columns
    @view_columns ||= {
      id:         { source: "Role.id", cond: :eq, searchable: false, orderable: false },
      name:       { source: "Role.name", cond: :like, searchable: true, orderable: true },
      activities: { source: "Role.activities", cond: :like, searchable: true, orderable: true },
      has_role:   { source: "Role.id",  searchable: false, orderable: false },
      action:     { source: "Role.id", searchable: false, orderable: false }
    }
  end

  def data
    records.map do |record|
      user_has_role = User.joins(:roles).where(roles: {id: record.id, special: true}, users: {id: options[:only_for_current_user_id]}).any?
      {
        id:         record.id,
        name:       record.try(:name_as_link),
        activities: record.try(:activities),
        has_role:   user_has_role ? '<div style="text-align: center"><div class="glyphicon glyphicon-ok"></div></div>'.html_safe : '',
        action:     link_add_remove(record, user_has_role).html_safe
      }
    end
  end

  private

  def get_raw_records
    Role.where(special: true).all
  end


  def link_add_remove(rec, has_role)
    if policy(rec).add_remove_role_user?
      if has_role
        "<div style='text-align: center'><button ajax-path='" + role_user_path(role_id: rec.id, id: options[:only_for_current_user_id]) + "' ajax-method='DELETE' class='btn btn-xs btn-danger glyphicon glyphicon-minus'></button></div>"
      else
        "<div style='text-align: center'><button ajax-path='" + role_users_path(role_id: rec.id, id: options[:only_for_current_user_id]) + "' ajax-method='POST' class='btn btn-xs btn-success glyphicon glyphicon-plus'></button></div>"
      end
    else
      ""
    end
  end



  # ==== These methods represent the basic operations to perform on records
  # and feel free to override them

  # def filter_records(records)
  # end

  # def sort_records(records)
  # end

  # def paginate_records(records)
  # end

  # ==== Insert 'presenter'-like methods below if necessary
end
