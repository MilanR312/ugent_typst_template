#import "../../template/prelude.typ": *
= The color blue
#introduction[We start by talking about how amazing the color blue is and end with why it is nice compared to other colors]
#todo[ talk about why it is amazing]
== The amazing color
#figure(
  image("images/blue.png"),
  caption: [A blue square]
)
== Compared to other colors
#figure(
  table(
    columns: 2,
    align: center,
    table.header([Color], [Reason]),
    [Blue], [Looks good],
    [Red], note(caption: [it is too red tbh])[it is too red]
  ),
  caption: [Colors]
)
