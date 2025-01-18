#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ["ContactManagement.Api/ContactManagement.Api.csproj", "ContactManagement.Api/"]
COPY ["ContactManagement.Application/ContactManagement.Application.csproj", "ContactManagement.Application/"]
COPY ["ContactManagement.Domain/ContactManagement.Domain.csproj", "ContactManagement.Domain/"]
COPY ["ContactManagement.InfraStructure/ContactManagement.InfraStructure.csproj", "ContactManagement.InfraStructure/"]

RUN dotnet restore "./ContactManagement.Api/ContactManagement.Api.csproj"

COPY . .

WORKDIR "/src/ContactManagement.Api"
RUN dotnet build "./ContactManagement.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "./ContactManagement.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ContactManagement.Api.dll"]