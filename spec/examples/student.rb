module Student

  include DCI::Role

  def do_homework!
    context.events << DomainEvents::HomeworkDone.new(self)
  end

end
