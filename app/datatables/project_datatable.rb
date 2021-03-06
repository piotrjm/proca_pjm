class ProjectDatatable < AjaxDatatablesRails::Base

  def_delegators :@view, :link_to, :project_path, :truncate

  def view_columns
    @view_columns ||= {
      id:        { source: "Project.id", cond: :eq, searchable: false, orderable: false },
      number:    { source: "Project.number", cond: :like, searchable: true, orderable: true },
      status:    { source: "ProjectStatus.name", cond: :like, searchable: true, orderable: true },
      deadline:  { source: "Project.deadline", cond: :like, searchable: true, orderable: true },
      note:      { source: "Project.note",  cond: :like, searchable: true, orderable: true },
      customer:  { source: "Customer.name", cond: :like, searchable: true, orderable: true },
      flat:      { source: "Project.id", cond: filter_custom_column_condition }
    }
  end

  def data
    records.map do |record|
      {
        id:       record.id,
        number:   link_to(record.number, project_path(record.id)),
        status:   record.project_status.try(:name),
        deadline: record.try(:deadline),
        note:     truncate(record.note, length: 50),
        customer: record.customer.try(:name_as_link),
        flat:     record.flat_assigned_users
      }
    end
  end

  private

  def get_raw_records
    #Project.joins(:project_status, :customer).all
    Project.includes(:project_status, :customer).references(:project_status, :customer).all
  end


  def filter_custom_column_condition
    #->(column) { ::Arel::Nodes::SqlLiteral.new(column.field.to_s).matches("#{ column.search.value }%") }
    ->(column) {
        sanitize_search_text = Loofah.fragment(column).text;
        sql_str = "(projects.id IN (" +
          "SELECT accessorizations.project_id FROM accessorizations, users WHERE " + 
          "accessorizations.user_id = users.id AND " + 
          "users.name ilike '%#{sanitize_search_text}%' " +
          "UNION " +
          "SELECT accessorizations.project_id FROM accessorizations, roles WHERE " + 
          "accessorizations.role_id = roles.id AND " + 
          "roles.name ilike '%#{sanitize_search_text}%' " +
          "))";
        ::Arel::Nodes::SqlLiteral.new("#{sql_str}") 
        }
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
