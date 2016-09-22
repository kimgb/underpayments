module LettersHelper
  def addressee_list(claim)
    if claim.employer && claim.workplace
      [claim.employer.contact, claim.employer.name, claim.workplace.contact, claim.workplace.name].uniq
    else
      []
    end
  end
  
  # Currently using Markdown for formatting - two spaces + newline formats as <br>
  def signature_list
    [
      ["General Branch - Sam Roberts", "#{ image_tag "signatures/sroberts.jpg" }  \nSam Roberts  \nGeneral Branch Secretary"], 
      ["Victoria Branch - Gary Maas", "#{ image_tag "signatures/gmaas.jpg" }  \nGary Maas  \nVictoria Branch Secretary"]
    ]
  end
end
