## install.packages('rsconnect')

library(rsconnect)

rsconnect::setAccountInfo(name='jmonlong',
			  token='XXX',
			  secret='XXX')

deployApp()
