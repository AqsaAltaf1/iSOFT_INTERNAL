# frozen_string_literal: true

json.array! @evaluations, partial: 'evaluations/evaluation', as: :evaluation
