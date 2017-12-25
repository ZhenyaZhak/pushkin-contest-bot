set :puma_threads, [4, 12]
set :puma_workers, 2

server "92.53.91.85", user: "deployer1", roles: %w{app web}
