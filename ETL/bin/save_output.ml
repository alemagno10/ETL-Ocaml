open Types

(** Converts a list of combined records into a list of output records.
  @param comb A list of combined records.
  @return A list of output records containing order ID, amount, and tax amount. *)
let generate_output (comb: combined list) : output list =
  List.map (fun c ->
    match c with 
    | Joined {order; item} -> 
      {order_id = order.id ; amount = item.price ; tax_amount = item.tax}
  ) comb ;;


(** Converts a list of combined records into a list of output records.
  @param comb A list of combined records.
  @return A list of output records containing order order_date, amount, and tax amount. *)
let generate_monthly_output (comb: combined list) : monthly_output list =
  List.map (fun c ->
    match c with 
    | Joined {order; item} -> 
      {date_of_order = order.order_date ; amount = item.price ; tax_amount = item.tax}
  ) comb ;;


(** Writes a list of output records to a CSV file.
  @param out A list of output records.
  @param filename The name of the output CSV file.
  @return Unit, but writes the data to the specified file. *)
let to_csv (out: output list) (filename: string) : unit = 
  let file = open_out filename in
  let csv_out = Csv.to_channel file in

  let rows = ["order_id"; "amount"; "tax_amount"] :: 
    List.map (fun o -> 
      [string_of_int o.order_id ; string_of_float o.amount ; string_of_float o.tax_amount]
    ) out 
  in
  Csv.output_all csv_out rows;
  close_out file ;;


(** Writes a list of output_monthly records to a CSV file.
  @param out A list of output_monthly records.
  @param filename The name of the output_monthly CSV file.
  @return Unit, but writes the data to the specified file. *)
let to_csv_monthly (out: monthly_output list) (filename: string) : unit = 
  let file = open_out filename in
  let csv_out = Csv.to_channel file in

  let rows = ["order_date"; "amount"; "tax_amount"] :: 
    List.map (fun o -> 
      [o.date_of_order ; string_of_float o.amount ; string_of_float o.tax_amount]
    ) out 
  in
  Csv.output_all csv_out rows;
  close_out file ;;
  
