module ProfilesHelper
  def own_profile?(profile)
    current_user.profile == profile
  end
end
