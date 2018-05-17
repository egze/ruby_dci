class DoHomework

  include DCI::Context

  attr_reader :student
  def initialize(boy:)
    @student = boy.extend(Student)
  end

  def call
    student.do_homework!
  end

end
