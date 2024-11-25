@then(u'run update-ca-trust in container and check its output returns 0')
def step_impl(context):
    container_id = context.container_id
    command = "update-ca-trust"
    exit_code, output = context.docker_client.exec_command(container_id, command)
    
    assert exit_code == 0, f"Command '{command}' failed with exit code {exit_code}. Output: {output}"
