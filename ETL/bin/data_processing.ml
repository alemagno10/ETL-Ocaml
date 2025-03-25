open Types

(** Groups a list of combined records by order ID, summing up prices and taxes.
  @param comb A list of combined records.
  @return A new list where each order ID appears only once, with summed item amounts and taxes. *)
let group_by_order_id (comb: combined list) : combined list =
  let grouped =
    List.fold_left (fun (acc: (int * combined) list) (row: combined) ->
      match row with 
      | Joined {order; item} ->
        match List.assoc_opt order.id acc with
        | Some (Joined { order = _; item = prev_item }) -> 
          let new_amount = prev_item.price +. item.price in 
          let new_tax_amount = prev_item.tax +. item.tax in
          let updated_item = Joined {
            order;
            item = { order_id = item.order_id ; product_id = 0 ; quantity = 0 ; price = new_amount ; tax = new_tax_amount}
          } 
          in
          (order.id, updated_item) :: List.remove_assoc order.id acc
        | None -> (order.id, row) :: acc
    ) [] comb
  in
  List.map snd grouped  
;;


(** Groups a list of combined records by order_date, averaging prices and taxes.
  @param comb A list of combined records.
  @return A new list where each order order_date appears only once, with summed item amounts and taxes divided by the amount of orders. *)
let mean_by_month_and_year (comb: combined list) : combined list =
  let grouped =
    List.fold_left (fun (acc: (string * combined) list) (row: combined) ->
      match row with
      | Joined {order; item} ->  
        let date = String.sub order.order_date 0 7 in 
        match List.assoc_opt date acc with
        | Some (Joined { order = _; item = prev_item }) ->
          let amt = float_of_int item.quantity in  
          let new_amount = ((prev_item.price *. amt) +. item.price) /. (amt +. 1.0) in 
          let new_tax_amount = ((prev_item.tax *. amt) +. item.tax) /. (amt +. 1.0) in
          let updated_item = Joined {
            order;
            item = { order_id = item.order_id ; product_id = 0 ; quantity = item.quantity+1 ; price = new_amount ; tax = new_tax_amount }
          } 
          in
          (date, (updated_item)) :: List.remove_assoc date acc
        | None -> (date, Joined { order; item = { item with quantity = 0 } }) :: acc 
    ) [] comb
  in
  List.map snd grouped
;;


(** Filters a list of combined records based on order status and origin.
  @param status The status to filter by (empty string means no filtering).
  @param origin The origin character to filter by (' ' means no filtering).
  @param orders A list of combined records.
  @return A filtered list of combined records that match the given criteria. *)
let filter_by (status: string) (origin: char) (orders: combined list): combined list = 
  let default_status = "" in  
  let default_origin = ' ' in  

  List.filter (fun c ->
    match c with 
    | Joined {order; _} ->
    (status = default_status || order.status = status) &&
    (origin = default_origin || order.origin = origin)
  ) orders ;; 
  

(** Computes the total price and tax amount for each item in the combined list.
  @param comb A list of combined records.
  @return A new list where each item's price and tax are updated based on its quantity. *)
let items_amount_processing (comb: combined list) : combined list = 
  List.map (fun c ->
    match c with 
    | Joined {order; item} ->
    let amount =  (float_of_int item.quantity) *. item.price in
    let tax_amount = (float_of_int item.quantity) *. item.price *. item.tax in
    Joined {
      order = order; 
      item = {item with price = amount ; tax = tax_amount}; 
    }
  ) comb ;;


(** Performs an inner join between items and orders based on order ID.
  @param items A list of item records.
  @param orders A list of order records.
  @return A list of combined records where each item is matched with its corresponding order. *)
let inner_join (items: item list) (orders: order list) : combined list =
  let orders_tuples = List.map (fun o -> (o.id, o)) orders in
  List.filter_map (fun (it: item) ->
    match List.assoc_opt it.order_id orders_tuples with
    | Some (o: order) -> 
        Some (Joined {
          order = o; 
          item = it; 
        })
    | None -> None
  ) items ;;