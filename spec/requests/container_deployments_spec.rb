describe "Container Deployments API" do
  it "supports OPTIONS requests without authorization" do
    options api_container_deployments_url
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body["data"]).to be_empty
  end

  it "supports collect-data with OPTIONS" do
    allow_any_instance_of(ContainerDeploymentService).to receive(:cloud_init_template_id).and_return(1)
    api_basic_authorize
    options api_container_deployments_url
    expect(response).to have_http_status(:ok)
    expect_hash_to_have_only_keys(response.parsed_body["data"], %w(deployment_types providers provision))
  end

  it "creates container deployment with POST" do
    allow_any_instance_of(ContainerDeployment).to receive(:create_deployment).and_return(true)
    api_basic_authorize collection_action_identifier(:container_deployments, :create)
    post(api_container_deployments_url, :params => gen_request(:create, :example_data => true))
    expect(response).to have_http_status(:ok)
  end
end
