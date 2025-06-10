class PasswordEntriesController < ApplicationController
  before_action :set_password_entry, only: [ :show, :edit, :update, :destroy ]

  def index
    @password_entries = current_user.password_entries
    @password_entries = @password_entries.search(params[:search]) if params[:search].present?
    @password_entries = @password_entries.order(:title)

    @password_entry = PasswordEntry.new
  end

  def show
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def create
    @password_entry = current_user.password_entries.build(password_entry_params)

    respond_to do |format|
      if @password_entry.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend("password_entries", partial: "password_entry", locals: { password_entry: @password_entry }),
            turbo_stream.update("password_entry_form", partial: "form", locals: { password_entry: PasswordEntry.new })
          ]
        end
        format.html { redirect_to password_entries_path, notice: "Password entry created successfully!" }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("password_entry_form", partial: "form", locals: { password_entry: @password_entry })
        end
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @password_entry.update(password_entry_params)
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@password_entry, partial: "password_entry", locals: { password_entry: @password_entry })
        end
        format.html { redirect_to password_entries_path, notice: 'Password entry updated successfully!' }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("edit_password_entry_#{@password_entry.id}", partial: "edit_form", locals: { password_entry: @password_entry })
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @password_entry.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(@password_entry)
      end
      format.html { redirect_to password_entries_path, notice: "Password entry deleted successfully!" }
    end
  end

  private

  def set_password_entry
    @password_entry = current_user.password_entries.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to password_entries_path, alert: "Password entry not found."
  end

  def password_entry_params
    params.require(:password_entry).permit(
      :title,
      :website_url,
      :encrypted_username,
      :encrypted_password,
      :encrypted_notes,
      :favorite
    )
  end
end
