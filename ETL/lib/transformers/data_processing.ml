(* open Types *)

type item = {
  order_id: int;
  product_id: int;
  quantity: int;
  price: float;
  tax: float;
}

type pro = {
  order_id: int;
  amount: float;
  tax_amount: float;
}

type order = {
  id: int;
  client_id: int;
  order_date: string;
  status: string;
  origin: char;
}

let group_by_order_id (products: pro list) : pro list =
  let grouped =
    List.fold_left (fun acc row ->
      match List.assoc_opt row.order_id acc with
      | Some item -> 
          let updated_item = {
            order_id = row.order_id;
            amount = row.amount +. item.amount; 
            tax_amount = row.tax_amount +. item.tax_amount;
          } 
          in
          (row.order_id, updated_item) :: List.remove_assoc row.order_id acc
      | None -> (row.order_id, row) :: acc
    ) [] products
  in
  List.map snd grouped  
;;

let filter_by (status: string) (origin: char) (orders: order list): order list = 
  let default_status = "" in  
  let default_origin = ' ' in  
  
  List.filter (fun o ->
    (status = default_status || o.status = status) &&
    (origin = default_origin || o.origin = origin)
  ) orders ;; 

  
let item_amount_processing (o: item) : pro = 
  let amount = (float_of_int o.quantity) *. o.price in
  let tax_amount = (float_of_int o.quantity) *. o.price *. o.tax in
  {order_id = o.order_id; amount = amount; tax_amount = tax_amount} ;;
