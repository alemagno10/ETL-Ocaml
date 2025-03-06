open Csv_reader 
open Item_reader
open Transformers

let () = print_endline "Hello, World!" ;;
let filename1 = Sys.getcwd () ^ "/data/order_item.csv" ;;

let () =
  let items = read_item_csv filename1 in
  (* let filtered = filter_by "Pending" ' ' orders in *)
  let processed_amount = List.map item_amount_processing items in 
  let p_a = group_by_order_id processed_amount in

  List.iter (fun o ->
    Printf.printf "OrderID: %d, Amount: %.2f, TaxAmount: %.2f\n"
      o.order_id o.amount o.tax_amount)
    p_a ;;
