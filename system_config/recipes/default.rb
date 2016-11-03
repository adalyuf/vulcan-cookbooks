node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  template "#{deploy[:deploy_to]}/current/config/system.yml" do
    source "system.yml.erb"
    group deploy[:group]
    owner deploy[:user]
    mode "0660"
    variables(:system_config => deploy[:system_config])

    notifies :run, "execute[restart Rails app #{application}]"

    only_if do
      deploy[:system_config].present? && File.directory?("#{deploy[:deploy_to]}/shared/config/")
    end
  end

  template "#{deploy[:deploy_to]}/current/config/secrets.yml" do
    source "secrets.yml.erb"
    group deploy[:group]
    owner deploy[:user]
    mode "0660"

    notifies :run, "execute[restart Rails app #{application}]"

    only_if do
      File.directory?("#{deploy[:deploy_to]}/shared/config/")
    end
  end
end
