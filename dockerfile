# Use a imagem do SQL Server
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
# Define o diretório de trabalho
WORKDIR /usr/src/app

# Define variáveis de ambiente
ENV ACCEPT_EULA=1
ENV SA_PASSWORD=TCFi@pF1

# Expõe a porta 1433 para conexões SQL
EXPOSE 1433

# Copy everything
COPY . ./

# Restore as distinct layers
RUN dotnet restore

# Build and publish a release
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /App
COPY --from=build-env /App/out .

ENTRYPOINT ["dotnet", "ContactManagement.dll"]


