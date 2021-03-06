# frozen_string_literal: true

class MachinesController < ApplicationController
  def create
    @machine = Machine.new(machine_params)

    respond_to do |format|
      if @machine.save
        format.html { redirect_to root_path, notice: 'Machine was successfully created.' }
      end
    end
  end

  def machine_users
    set_machine
    @users = User.where.not(role: 'admin')
  end

  def assign_user_machine
    set_machine
    user = User.find_by(email: params['email'])
    ap 'create'
    umach = UserMachine.new(user: user, machine: @machine)
    umach.generate_username
    umach.save!
    head :ok
  end

  def unassign_user_machine
    set_machine
    user = User.find_by(email: params['email'])
    umach = UserMachine.find_by(user: user, machine: @machine)
    umach&.delete
    user_machines = user.user_machines
    ap user_machines
    head :ok
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_machine
    @machine = Machine.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def machine_params
    params.require(:machine).permit(:name, :ip, :sequence, :image_src)
  end
end
