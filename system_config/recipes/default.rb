node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  template "#{deploy[:deploy_to]}/shared/config/system.yml" do
    source "system.yml.erb"
    group deploy[:group]
    owner deploy[:user]
    mode "0660"
    variables(:system_config => deploy[application][:system_config])

    only_if do
      deploy[:system_config].present? && File.directory?("#{deploy[:deploy_to]}/shared/config/")
    end
  end
end
