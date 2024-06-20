#let global_table_counters = state("gtc", (:))
#let global_table_state = state("gts", (:))



#let note(body, caption: none) = {
  [\_internalNoteMarker#(caption)internalsplitpoint#body]
}
#let init_note_tables(body) = {
  show table: t => context {
    let table_num = counter(figure.where(kind: table)).get().first()
    global_table_counters.update(s => {
      s.insert(str(table_num), counter(str(table_num)))
      s
    })
    global_table_state.update(s => {
      s.insert(str(table_num), (:))
      s
    })
    t
    align(left, 
      text(size: 10pt)[
        #context{
          for (idx,note) in global_table_state.final().at(str(table_num)).pairs() {
            if note == [] {
              continue
            }
            [#idx: #note]
            linebreak()
        }
      }
    ]
  )
}
  show table.cell: c => context {
    if not c.body.has("children"){
      return c
    }
    let children = c.body.children
    if children.len() < 2 {
      return c
    }
    if not (children.at(0) == [\_] and children.at(1) == [internalNoteMarker]){
      return c
    }
    let remaining = children.slice(2)
    let split_index = remaining.position(c => c == [internalsplitpoint])

    let caption = remaining.slice(0, split_index).join()

    
    let text = remaining.slice(split_index+1).join()
    
    let table_num = counter(figure.where(kind: table)).get().first()
    global_table_counters.get().at(str(table_num)).step()
    let x = global_table_counters.get().at(str(table_num)).get().first()
    global_table_state.update(s => {
      let data = s.at(str(table_num))
      data.insert(str(x+1), caption)
      s.insert(str(table_num), data)
      s
    })

    let note_block = place.with(top + right)
    
    table.cell(
      align: c.align,
      breakable: c.breakable,
      colspan: c.colspan,
      fill: c.fill,
      inset: c.inset,
      rowspan: c.rowspan,
      stroke: c.stroke,
      x: c.x,
      y: c.y
    )[
      #pad(right: 10pt, top: 2pt)[#text] #note_block[#(x+1)]
    ]   
  }
  body
}

