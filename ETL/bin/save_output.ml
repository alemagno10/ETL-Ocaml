open Types

let generate_output (comb: combined list) : output list =
  List.map (fun c ->
    match c with 
    | Joined {order; item} -> 
      {order_id = order.id ; amount = item.price ; tax_amount = item.tax}
  ) comb ;;