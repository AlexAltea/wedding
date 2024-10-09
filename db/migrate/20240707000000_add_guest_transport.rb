# frozen_string_literal: true

class AddGuestTransport < ActiveRecord::Migration[5.1]
  def change
    change_table :guests do |t|
      t.boolean :transport
    end
    update_view :attendees, version: 2, revert_to_version: 1
  end
end
