ARG VARIANT=3.9
FROM mcr.microsoft.com/vscode/devcontainers/python:${VARIANT}

RUN pip3 install dbt-duckdb==1.3.3 pandas==1.5.2 pyarrow==10.0.1 shandy-sqlfmt[jinjafmt]==0.14.2
