class ApplicantsIndex < Datatable::Base

  count <<-SQL
    SELECT COUNT(*)
    FROM (
      SELECT
        applicants.id,
        IF(middlename IS NULL or middlename = '',
            CONCAT_WS(' ', firstname, lastname),
            CONCAT(firstname, ' ', UCASE(LEFT(middlename,1)), '. ', lastname)
        ) AS fullname,
        positions.title AS position,
        applicants.status AS status,
        'Show Info' AS ' '
      FROM
        applicants
      INNER JOIN positions
      ON applicants.position_id = positions.id
    ) AS applicants
  SQL


  sql <<-SQL
    SELECT *
    FROM(
      SELECT
        applicants.id,
        IF(middlename IS NULL or middlename = '',
            CONCAT_WS(' ', firstname, lastname),
            CONCAT(firstname, ' ', UCASE(LEFT(middlename,1)), '. ', lastname)
        ) AS fullname,
        positions.title AS position,
        applicants.status AS status,
        'Show Info' AS ' '
      FROM
        applicants
      INNER JOIN positions
      ON applicants.position_id = positions.id
    ) AS applicants
  SQL

  columns(
    {"applicants.id" => {:type => :integer, :bVisible=>false}},
    {"fullname" => {:type => :string, :sTitle => "name"}},
    {"position" => {:type => :string, :sTitle => "Position"}},
    {"status" => {:type => :string, :sTitle => "Status"}},
    {' ' => {:type => :string, :bSortable=> false, :bSearchable => false}}
  )

# :link_to => link_to('show info', applicant_path('{{0}}'))

 # // 'full' is the row's data object, and 'data' is this column's data
 # // e.g. 'full[0]' is the comic id, and 'data' is the comic title

  colDef = []
  colTarget = 4
  render = "function( data, type, full, meta){ return '<a href='#'>data</a>;' }"


  colDef << {:sortable => false, :targets => [colTarget], :render => render}

  option("aoColumnDefs", colDef)


  # option('bJQueryUI', true)
  # option('individual_column_searching', true)
  option("aLengthMenu", %w{3 5 10})
  option("pageLength", 5)
  #   sql <<-SQL
  #     SELECT
  #       orders.id,
  #       orders.order_number,
  #       customers.first_name,
  #       customers.last_name,
  #       orders.memo
  #     FROM
  #       orders
  #     JOIN
  #       customers ON customers.id = orders.customer_id
  # SQL

  # columns(
  #   {"orders.id" => {:type => :integer, :sTitle => "Id", :sWidth => '50px'}},
  #   {"orders.order_number" => {:type => :integer, :link_to => link_to('{{1}}', order_path('{{0}}')),:sTitle => 'Order Number', :sWidth => '125px'  }},
  #   {"customers.first_name" => {:type => :string, :link_to => link_to('{{2}}', order_path('{{0}}')),:sWidth => '200px' }},
  #   {"customers.last_name" => {:type => :string,:sWidth => '200px'}},
  #   {"orders.memo" => {:type => :string }}
  # )
  # option('bJQueryUI', true)
  # option('individual_column_searching', true)
  # #option('sDom', '<"H"lrf>t<"F"ip>')    # use with pagination
  # # to use pagination comment out following and enable previous line
  # option('sDom', '<"clear"><"H"Trf>t<"F"i>')
  # option('bScrollInfinite', true)
  # option('bScrollCollapse', true)
  # option('sScrollY', '200px')

end

