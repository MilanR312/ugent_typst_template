#import "ugent_template.typ": ugent-template, gls, make-glossary, init_note_tables

#show: make-glossary
#show: init_note_tables


#show: ugent-template.with(
  title: [
    #text([A real thesis about colors], size: 25pt)

  ],
  short_title: [Colors],
  language: "nl",
  team_text: none,
  authors: (
    (
      name: "John Doe",
      student_number: "00",
      email: "test"
    ),
  ),
  other_people: (
    begeleiders: (
      "Jane doe",
    ),
    promotors: none
  ),
  //glossary-file: "glos.yml",
  //bibliography-file: "refs.yml",
)
#include "chapters/c1/text.typ"
  