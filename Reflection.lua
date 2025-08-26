-- Função para deixar qualquer objeto refletivo
local function makeReflective(obj)
	if obj:IsA("BasePart") then
		obj.Reflectance = 1              -- máxima reflexão
		obj.Material = Enum.Material.SmoothPlastic -- material refletivo
		obj.CastShadow = false              -- opcional, evita sombras
	end

	-- Aplicar recursivamente aos filhos
	for _, child in ipairs(obj:GetChildren()) do
		makeReflective(child)
	end
end

-- Aplica a tudo que já existe no Workspace
makeReflective(game.Workspace)
makeReflective(game.Lighting)
makeReflective(game.ReplicatedStorage)
makeReflective(game.ServerStorage)
makeReflective(game.StarterGui)
makeReflective(game.StarterPack)
makeReflective(game.StarterPlayer)

-- Deixar objetos novos refletivos automaticamente
local function onChildAdded(obj)
	makeReflective(obj)
	-- Aplica também recursivamente aos filhos que forem adicionados depois
	obj.DescendantAdded:Connect(makeReflective)
end

-- Conectar ChildAdded em lugares importantes
game:GetDescendants() -- percorre tudo para conectar ChildAdded
for _, obj in ipairs(game:GetDescendants()) do
	if obj:IsA("Folder") or obj:IsA("Model") or obj:IsA("BasePart") then
		obj.ChildAdded:Connect(onChildAdded)
	end
end

-- Também aplica a novos objetos no Workspace direto
game.Workspace.ChildAdded:Connect(onChildAdded)
