orderInput('items1', 'Items1', items = month.abb, item_class = 'info')

## build connections between orderInputs
orderInput('items2', 'Items2 (can be moved to Items1 and Items4)', items = month.abb,
           connect = c('lst1', 'lst4'), item_class = 'primary')

## build connections in source mode
orderInput('items3', 'Items3 (can be copied to List2 and List4)', items = month.abb,
           as_source = TRUE, connect = c('lst2', 'lst4'), item_class = 'success')

## show placeholder
orderInput('items4', 'Items4 (can be moved to List2)', items = NULL, connect = 'lst2',
           placeholder = 'Drag items here...')
