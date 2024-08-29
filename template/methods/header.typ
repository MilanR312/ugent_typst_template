#import "globals.typ": *


#let default_header(title, short_title) = context{
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