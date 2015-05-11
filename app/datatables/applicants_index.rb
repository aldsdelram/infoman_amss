class ApplicantsIndex < Datatable::Base

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
        CONCAT('<a href="/applicants/', applicants.id, '" > Show Info </a>') AS ' ',
        IF(middlename IS NULL or middlename = '',
            CONCAT_WS(' ', firstname, lastname),
            CONCAT(firstname, ' ', middlename, '. ', lastname)
        ) AS fullname2,
        CONCAT_WS(' ', firstname, lastname) AS name_without_m
      FROM
        applicants
      INNER JOIN positions
      ON applicants.position_id = positions.id
    ) AS applicants
  SQL

  columns(
    {"applicants.id" => {:type => :integer, :bVisible=>false}},
    {"fullname" => {:type => :string, :sTitle => "Name"}},
    {"position" => {:type => :string, :sTitle => "Position"}},
    {"status" => {:type => :string, :sTitle => "Status"}},
    {' ' => {:type => :string, :bSortable=> false, :bSearchable => false}},
    {'fullname2' => {:type => :string, :bVisible => false, :bSearchable => true}},
    {'name_without_m' => {:type => :string, :bVisible => false, :bSearchable => true}}
  )

  option("aLengthMenu", %w{3 5 10})
  option("pageLength", 5)
  option('sDom', 'lrf<"clear"><"table-responsive"t>ip<"clear"><"clearfix">')
  option('retreive', true)
end
