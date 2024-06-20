#import "globals.typ" : ublue

#let title_page(
  title: none,
  authors: (),
  other_people: ()
) = {
    // display the papers layout

  align(
    image("../images/faculteit.png", width: 60%),
    left + top
  )
  
  align(
    [
      #set text(stroke: ublue, fill: ublue)
      #title
    ],
    left + horizon
  )
  align(
    for author in authors [
      #set text(16pt)
      #author.name
      
      #set text(12pt)
      student number: #author.studenten_nummer
    
    ],
    left + bottom
  )
  v(3em)
  align(
    [
      #set text(14pt)
      #if other_people != none and other_people.promotors != none [
        Promotors: #other_people.promotors.join(", ")
      ]
      
      #if other_people != none and other_people.begeleiders != none [
        Supervisors: #other_people.begeleiders.join(", ")
      ]
    ],
    left + bottom
  )
  v(3em)
  image("../images/ugent.png", width: 30%)
  


  pagebreak()
}