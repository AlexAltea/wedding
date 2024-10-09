# frozen_string_literal: true

class CreateAttendees < ActiveRecord::Migration[5.1]
  def change
    create_view :attendees, version: 1
  end
end
