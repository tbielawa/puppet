Puppet::Type.type(:user).provide :hpuxuseradd, :parent => :useradd do
  desc "User management for HP-UX. This provider uses the undocumented `-F`
    switch to HP-UX's special `usermod` binary to work around the fact that
    its standard `usermod` cannot make changes while the user is logged in."

  defaultfor :operatingsystem => "hp-ux"
  confine :operatingsystem => "hp-ux"

  commands :modify => "/usr/sam/lbin/usermod.sam", :delete => "/usr/sam/lbin/userdel.sam", :add => "/usr/sbin/useradd"
  options :comment, :method => :gecos
  options :groups, :flag => "-G"
  options :home, :flag => "-d", :method => :dir

  verify :gid, "GID must be an integer" do |value|
    value.is_a? Integer
  end

  verify :groups, "Groups must be comma-separated" do |value|
    value !~ /\s/
  end

  has_features :manages_homedir, :allows_duplicates

  def deletecmd
    super.insert(1,"-F")
  end

  def modifycmd(param,value)
    super.insert(1,"-F")
  end
end
