# frozen_string_literal: true

class NotesController < ApplicationController
  def index
    @notes = Note.all
  end

  def new
    @note = Note.new
  end

  def create
    if params[:note][:type] == 'Leave'
      leave = Leave.find(params[:note][:note_created_on])
      @note = leave.notes.build(note_params)
    elsif params[:note][:type] == 'Request'
      request = Request.find(params[:note][:note_created_on])
      @note = request.notes.build(note_params)
    else
      evaluation = Evaluation.find(params[:note][:note_created_on])
      @note = evaluation.notes.build(note_params)
    end
    @note.user_id = current_user.id
    if @note.save
      if leave
        redirect_to(leave_path(leave), turbo: true, notice: 'Note has been created')
      elsif request
        redirect_to(request_path(request), turbo: true, notice: 'Note has been created')
      else
        redirect_to evaluation_path(evaluation)
      end
    else
      render :new
    end
  end

  def pending_leave(user)
    user.first.leaves.selected_leaves('pending').first
  end

  private

  def note_params
    params.require(:note).permit(:content)
  end
end
