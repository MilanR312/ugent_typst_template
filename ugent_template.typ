#import "template/methods/globals.typ": ublue, default_font, default_fontsize, parlead
#import "template/methods/title_page.typ": *
#import "template/methods/glos.typ": *
#import "template/methods/todo.typ": *
#import "template/methods/introduction.typ": *
#import "template/methods/table_notes.typ": init_note_tables




#let ugent-template(
  title: none,
  short_title: none,
  authors: (),
  other_people: (),
  language: "en",
  team_text: none,
  include_copyright: false,
  bibliography-file: none,
  glossary-file: none,
  body,
) = {
  set document(author: authors.map(author => author.name), title: title)

  
  state("appendix").update(false)
  state("body").update(false)
  set text(
    lang: language,
    fallback: true,
    font: default_font,
    size: default_fontsize,
    hyphenate: false,
    overhang: true,
  )
  set quote(block: true)
  // Configure equation numbering and spacing.
  set math.equation(numbering: "(1)", block: true)
  show math.equation: set block(spacing: 1.65em)
  
  set page(number-align: right, margin: 2.5cm, paper: "a4", numbering: none)
  
  set par(justify: false, first-line-indent: 0em) //change to 1em for actual texts
  show par: set block(spacing: 1em)
  
  // Configure lists.
  set enum(indent: 10pt, body-indent: 9pt)
  set list(indent: 10pt, body-indent: 9pt)
  

  
  show figure.where(kind: table): set figure.caption(position: top)
  show figure: set block(breakable: true)

  
  set figure(supplement: n => {
    if n.func() == image {
      "Figure"
    } else if n.func() == table {
      "Table"
    } else if n.func() == raw {
      "Code fragment"
    } else if n.func() == math.equation {
      "Equation"
    } else {
      "Unkown item, append to template at line 336"
    }
  })
  
  

  
  // set copyright
  align(
    if include_copyright == true [
      #sym.copyright 2023-2024  
      #authors.map(author => author.name).join(", ")
      Ghent University
      
      All rights reserved. No part of this book may be reproduced or transmitted in any form or by any means, electronic, mechanical, photocopying, recording, or otherwise, without the prior written permission of the author(s).
      #pagebreak()
    ],
    bottom
  )
  state("init").update(true)

  title_page(title: title, authors: authors, other_people: other_people)
  pagebreak()
  title_page(title: title, authors: authors, other_people: other_people)

  show link: it => if type(it.dest) == str {
    //set text(stroke: ublue)
    underline(it)
  } else {
    it
  }
  
  //counter(page).update(1)

  set page(footer: locate(
    loc => if calc.even(loc.page()) {
      align(right, counter(page).display("I"));
    } else {
      align(left, counter(page).display("I"));
    }
  ))
  set page(header: context{
      let titles_before = query(
        heading.where(level: 1).before(here())
      ).rev().filter(x => state("body").at(x.location()) or state("appendix").at(x.location()))
      
      let all_headings = query(
        heading.where(level: 1)
      ).filter(x => state("body").at(x.location()) or state("appendix").at(x.location()))
      let current_page = counter(page).at(here())
      let is_on_same_page = false
      for header in all_headings {
        let page_of_header = counter(page).at(header.location())
        if current_page == page_of_header{
          is_on_same_page = true
        }
      }
      let is_on_title_page = (is_on_same_page and state("init").get() == false) or titles_before.len() == 0
      let is_in_body = state("body").get()
      let is_in_appendix = state("appendix").get()
      set text(size: default_fontsize)
      if not is_on_title_page and (is_in_body or is_in_appendix){
        let title = titles_before.first()
        let current_page = counter(page).get().first()
        let title_page = counter(page).at(title.location()).first()
        let pagediff = (current_page - title_page)
        
        if calc.even(pagediff) {
          grid(
            columns: (20%, 60%, 20%),
            [], align(short_title, center), align(title.body, right)
          )
        } else {
          let curr = query(selector(heading.where(level: 1)).before(here())).last()
          let numb = numbering(curr.numbering, counter(curr.func()).at(curr.location()).first())
          grid(
            columns: (20%, 60%, 20%),
            align(
            [#curr.supplement #numb],
            left
            ), align(short_title, center), []
          )
        }
        line(length: 100%)
      } else {
        align(short_title, center)  
        align(line(length: 80%), center)
      }
      
    }
  )
  // dit is een copy van later, alle begin titels hebben ook een grote display maar geen nummering
  //we stellen wel een counter in sinds het nodig is
  counter(heading).update(0)
  show heading: it => {
    let header_count = counter(heading).at(it.location())
    set text(stroke: ublue, fill: ublue)
    set par(first-line-indent: 0pt)
    if it.level == 1 {
      //highest level headers are blue and have a big number
      set text(size: 80pt, weight: "thin", fill: luma(50%), stroke: luma(50%))
      pagebreak(weak: true)
      v(1em)
      counter(heading).step()
      set text(size: 25pt, weight: "extrabold", stroke: ublue, fill: ublue)
      align(
        it,
        right
      )
    } else if it.level == 2 {
      set text(size: 20pt, weight: "extrabold", stroke: ublue, fill: ublue)
      it
      v(0.2em)
    } else if it.level == 3 {
      set text(size: 18pt, weight: "extrabold", stroke: ublue, fill: ublue)
      it
    } else {
      it
    }
  }
  
  {
    set par(leading: parlead)
    include "template/prependices.typ"
    pagebreak(weak: true)
  }
  
  show outline.entry: it => {
    let loc = it.element.location()
    if state("init").at(loc) == true {
      //in the init state we only show the highest headers and we show it in roman numerals
      let page = numbering("I", ..counter(page).at(loc))
      let body = it.element.body
      if it.element.level == 1 [
        #link(loc)[
           #body
        ]#box(width: 1fr, it.fill)#page
      ]
    } else {
      it
    }
  }
  outline(indent: 1em, depth: 3)
  pagebreak()

  //toont enkel image en table overzicht indien er bestaan
  context { 
    if counter(figure.where(kind: image)).final().first() != 0 {
      outline(title: "Figures", target: figure.where(kind: image))
      pagebreak()
      
    }
  }
  context { 
    if counter(figure.where(kind: table)).final().first() != 0 {
      outline(title: "Tables", target: figure.where(kind: table))
      pagebreak()
      
    }
  }
  context { 
    if counter(figure.where(kind: math.equation)).final().first() != 0 {
      outline(title: "Equations", target: figure.where(kind: math.equation))
      pagebreak()
      
    }
  }
  if glossary-file != none {
    glossary(glossary-file, full: true)
  }
  outline-todos()
  
  state("init").update(false)
  state("body").update(true)
  

  counter(heading).update(0)
  set page(footer: {
    set text(size: default_fontsize)
    grid(
      columns: (50%, 50%),
      if team_text != none [#team_text] else [], align(right, counter(page).display("1"))
    ) 
  })
  //set page(footer: align(right, counter(page).display("1")));
  set heading(numbering: "1.1.1", supplement: [Chapter])

  show heading: it => {
    let header_count = counter(heading).at(it.location())
    set text(stroke: ublue, fill: ublue)
    set par(first-line-indent: 0pt)
    if it.level == 1 {
      //highest level headers are blue and have a big number
      set text(size: 80pt, weight: "thin", fill: luma(50%), stroke: luma(50%))
      pagebreak(weak: true)
      v(1em)
      align(
        numbering(it.numbering, ..header_count),
        right
      )
      set text(size: 30pt, weight: "extrabold", stroke: ublue, fill: ublue)
      align(
        it.body,
        right
      )
    } else if it.level == 2 {
      set text(size: 24pt, weight: "extrabold", stroke: ublue, fill: ublue)
      it
      v(0.2em)
    } else if it.level == 3 {
      set text(size: 19pt, weight: "extrabold", stroke: ublue, fill: ublue)
      it
    } else {
      set text(size: 16pt)
      set text(weight: 300)
      
      it.body
    }
  }

  pagebreak(weak: false)
  counter(page).update(1)
  

  

  //show: gloss-init
  set par(leading: parlead)
  body
  pagebreak(weak: true)
  // Display bibliography.
  if bibliography-file != none {
    show bibliography: set text(8pt)
    [
      = Bibliograpy
    ]
    bibliography(bibliography-file, title: none, style: "ieee")
  }
  state("body").update(false)
  state("appendix").update(true)
  
  set heading(numbering: "A.1.1.1", supplement: [Appendix])
  counter(heading).update(0)
  pagebreak(weak: true)

  include "template/appendices.typ"
  pagebreak(weak: true)
}
