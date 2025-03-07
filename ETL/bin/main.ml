open Item_reader
open Order_reader
open Data_processing
(* open Save_output *)
open Types

let () =
  let filename1 = Sys.getcwd () ^ "/data/order_item.csv" in
  let filename2 = Sys.getcwd () ^ "/data/order.csv" in
  
  let items = read_item_csv filename1 in
  let orders = read_order_csv filename2 in

  let combined_values = inner_join items orders in
  let filtered_combined_values = filter_by "Cancelled" 'O' combined_values in
  let processed_amount = items_amount_processing filtered_combined_values in 
  let grouped_processed_amount = group_by_order_id processed_amount in

  List.iter (fun c ->
    match c with 
    | Joined {order; item} ->
    Printf.printf "OrderID: %d, ProductID: %d, Quantity: %d, Price: %.2f, Tax: %.2f, ID: %d, ClientID: %d, Date: %s, Status: %s, Origin: %c\n"
    item.order_id item.product_id item.quantity item.price item.tax order.id order.client_id order.order_date order.status order.origin
  ) grouped_processed_amount ;;
  


  (* let output = generate_output grouped_processed_amount in
  
  List.iter (fun o ->
    Printf.printf "OrderID: %d, Amount: %.2f, TaxAmount: %.2f\n"
      o.order_id o.amount o.tax_amount)
    output  *)
