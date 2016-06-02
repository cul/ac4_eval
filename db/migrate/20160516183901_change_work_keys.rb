class ChangeWorkKeys < ActiveRecord::Migration
  def change
    rename_column :featured_works, :generic_work_id, :work_id
    rename_column :trophies, :generic_work_id, :work_id
    rename_column :proxy_deposit_requests, :generic_work_id, :work_id
    rename_column :proxy_deposit_requests, :generic_work_id, :work_id if ProxyDepositRequest.column_names.include?('generic_file_id')
  end
end
