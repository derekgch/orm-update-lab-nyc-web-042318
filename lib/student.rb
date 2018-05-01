require_relative "../config/environment.rb"
require 'pry'

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name="",grade="",id=nil)
    @id = id
    @name = name
    @grade = grade
  end


  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students
    SQL

    DB[:conn].execute(sql)
  end

  def self.create(name, grade)
    new_s = Student.new(name,grade)
    new_s.save
    # new_s
  end

  def self.new_from_db(row)
    Student.new(row[1],row[2],row[0])

  end

  def self.find_by_name(name)
    data = DB[:conn].execute("SELECT * from students WHERE name = ?", name)
    if(!data.empty?)
      self.new_from_db(data[0])
    else
      nil
    end
  end

  def update
    if(@id != nil)
      DB[:conn].execute("UPDATE students SET name = ?, grade = ? WHERE id = ?", self.name, self.grade, self.id)
    else
      nil
    end


  end

  def save
    if(@id != nil)
      DB[:conn].execute("UPDATE students SET name = ? WHERE id = ?", self.name, self.id)
    else
      sql = <<-SQL
      INSERT INTO students (name,grade) values (?,?)

      SQL

      DB[:conn].execute(sql,self.name,self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() from students")[0][0]
    end
  end

end
