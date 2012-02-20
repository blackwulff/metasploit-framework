##
# $Id$
##

##
# This file is part of the Metasploit Framework and may be subject to
# redistribution and commercial restrictions. Please see the Metasploit
# Framework web site for more information on licensing and terms of use.
# http://metasploit.com/framework/
##


require 'msf/core'
require 'msf/core/exploit/vim_soap'


class Metasploit3 < Msf::Auxiliary

	include Msf::Exploit::Remote::HttpClient
	include Msf::Auxiliary::Report
	include Msf::Exploit::Remote::VIMSoap
	include Msf::Auxiliary::Scanner

	def initialize
		super(
			'Name'           => 'VMWare Enumerate Host Details',
			'Version'        => '$Revision$',
			'Description'    => %Q{
								This module attempts to enumerate information about the host systems through the VMWare web API.
								This can include information about the hardware installed on the host machine.},
			'Author'         => ['TheLightCosine <thelightcosine[at]metasploit.com>'],
			'License'        => MSF_LICENSE
		)

		register_options(
			[
				Opt::RPORT(443),
				OptString.new('USERNAME', [ true, "The username to Authenticate with.", 'root' ]),
				OptString.new('PASSWORD', [ true, "The password to Authenticate with.", 'password' ]),
				OptBool.new('HW_DETAILS', [true, "Enumerate the Hardware on the system as well?", false])
			], self.class)
	end

	def run_host(ip)

		if vim_do_login(datastore['USERNAME'], datastore['PASSWORD']) == :success
			output = "VMWare Host at #{ip} details\n"
			output << "-----------------------------\n"
			host_summary = vim_get_all_host_summary(datastore['HW_DETAILS'])
			output << YAML.dump(host_summary)
			print_good output
			store_loot('vmware_host_details', "text/plain", datastore['RHOST'], output, "#{datastore['RHOST']}_vmware_host.txt", "VMWare Host Details")
		else
			print_error "Login Failure on #{ip}"
			return
		end
	end





end

