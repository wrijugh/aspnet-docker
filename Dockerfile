FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["aspnet-docker.csproj", "./"]
RUN dotnet restore "aspnet-docker.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "aspnet-docker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "aspnet-docker.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "aspnet-docker.dll"]
