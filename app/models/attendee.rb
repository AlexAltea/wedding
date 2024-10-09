# frozen_string_literal: true

#
# A guest or plus one.
#
class Attendee < ApplicationRecord
  scope :diet?, -> { where.not(diet: nil) }
  scope :child?, -> { where(child: true) }

  # HACK: This should be fixed in schema.rb by adding setting plus-one transport to their parent guests transport value.
  def corrected_transport
    if plus_one?
      guest_id = extract_guest_id
      guest = Attendee.find_by(id: guest_id)
      guest ? guest.transport : transport
    else
      transport
    end
  end

  private

  def plus_one?
    id.include?('-')
  end

  def extract_guest_id
    id.split('-').first
  end
end
