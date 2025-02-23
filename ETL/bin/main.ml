open Csv_reader

let () = print_endline "Hello, World!" ;;
let filename1 = Sys.getcwd () ^ "/data/order.csv"
let filename2 = Sys.getcwd () ^ "/data/order_item.csv" ;;

let () =
  let orders = Order_reader.read_order_csv filename1 in
  Printf.printf "Number of orders: %d\n" (List.length orders);
  (* List.iter (fun o ->
    Printf.printf "ID: %d, Client: %d, Date: %s, Status: %s, Origin: %c\n"
      o.id o.client_id o.order_date o.status o.origin)
    orders

let () =
  let items = Item_reader.read_item_csv filename2 in
  List.iter (fun o ->
    Printf.printf "ID: %d, Product: %d, Quantity: %d, Price: %f, Tax: %f\n"
      o.order_id o.product_id o.quantity o.price o.tax)
      items *)


