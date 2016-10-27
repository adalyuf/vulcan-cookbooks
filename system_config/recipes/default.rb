node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  template "#{deploy[:deploy_to]}/shared/config/system.yml" do
    source "system.yml.erb"
    group deploy[:group]
    owner deploy[:user]
    mode "0660"

    only_if do
      File.directory?("#{deploy[:deploy_to]}/shared/config/")
    end
  end
end
