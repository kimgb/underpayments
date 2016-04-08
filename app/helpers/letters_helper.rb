module LettersHelper
  def addressee_list(claim)
    if claim.employer && claim.workplace
      if claim.employer == claim.workplace
        [claim.employer.contact, claim.employer.name]
      else
        [claim.employer.contact, claim.employer.name, claim.workplace.contact, claim.workplace.name]
      end
    else
      []
    end
  end
  
  # Currently using Markdown for formatting - two spaces + newline formats as <br>
  def signature_list
    [
      ["General Branch - Sam Roberts", "Sam Roberts  \nGeneral Branch Secretary"], 
      ["Victoria Branch - Gary Maas", "Gary Maas  \nVictoria Branch Secretary"]
    ]
  end
end
