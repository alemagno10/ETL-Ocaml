open Item_reader
open Order_reader
open Data_processing
open Save_output

let () =
  let filename1 = Sys.getcwd () ^ "/data/order_item.csv" in
  let filename2 = Sys.getcwd () ^ "/data/order.csv" in
  
  let items = read_item_csv filename1 in
  let orders = read_order_csv filename2 in

  let combined_values = inner_join items orders in
  let filtered_combined_values = filter_by "" ' ' combined_values in
  let processed_amount = items_amount_processing filtered_combined_values in 
  let grouped_processed_amount = group_by_order_id processed_amount in
  
  let output = generate_output grouped_processed_amount in
  let output_filename = Sys.getcwd () ^ "/data/output.csv" in
  to_csv output output_filename ;
  
  let median = median_by_month_and_year grouped_processed_amount in
  let monthly_output = generate_monthly_output median in
  let output_filename = Sys.getcwd () ^ "/data/monthly_output.csv" in
  to_csv_monthly monthly_output output_filename ;;
