orderInput('items1', 'Items1', items = month.abb, item_class = 'info')

## build connections between orderInputs
orderInput('items2', 'Items2 (can be moved to Items1 and Items4)', items = month.abb,
           connect = c('items1', 'items4'), item_class = 'primary')

## build connections in source mode
orderInput('items3', 'Items3 (can be copied to Items2 and Items4)', items = month.abb,
           as_source = TRUE, connect = c('items2', 'items4'), item_class = 'success')

## show placeholder
orderInput('items4', 'Items4 (can be moved to Items2)', items = NULL, connect = 'items2',
           placeholder = 'Drag items here...')
