type item = {
  order_id: int;
  product_id: int;
  quantity: int;
  price: float;
  tax: float;
}

let parse_item_row (row: string list) : item =
  match row with 
  | [order_id; product_id; quantity; price; tax] ->
    let order_id = int_of_string order_id in
    let product_id = int_of_string product_id in
    let quantity = int_of_string quantity in
    let price = float_of_string price in
    let tax = float_of_string tax in
    { order_id; product_id; quantity; price; tax } 
  | _ -> 
      Printf.printf "Skipping invalid row: %s\n" (String.concat ", " row);
      { order_id = 0; product_id = 0; quantity = 0; price = 0.; tax = 0. } 

let read_item_csv filename =
  let data = Csv.load filename in
  let rows = List.tl data in
  List.map parse_item_row rows ;;
  