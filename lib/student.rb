class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    create_student_table = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      );
    SQL
    DB[:conn].execute(create_student_table)
  end

  def self.drop_table
    drop_student_table = <<-SQL
      DROP TABLE students;
    SQL
    DB[:conn].execute(drop_student_table)
  end

  def save
    save_student = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?);
    SQL
    DB[:conn].execute(save_student, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students;")[0][0]
  end

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end

end
