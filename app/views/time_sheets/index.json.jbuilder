# frozen_string_literal: true

json.array! @time_sheets, partial: 'time_sheets/time_sheet', as: :time_sheet
