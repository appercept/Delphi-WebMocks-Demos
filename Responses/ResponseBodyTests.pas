unit ResponseBodyTests;

interface

uses
  DUnitX.TestFramework,
  System.Net.HttpClient,
  WebMock;

type
  [TestFixture]
  TResponseBodyTests = class
  private
    Client: THTTPClient;
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure WithBody_GivenString_ReturnsStringAsPlainText;
    [Test]
    procedure WithBody_GivenContentType_ReturnsStringAsContentType;
    [Test]
    procedure WithBodyFile_GivenFilePath_ReturnsFileWithInferredContentType;
    [Test]
    procedure WithBodyFile_GivenContentType_ReturnsStringAsContentType;
  end;

implementation

procedure TResponseBodyTests.Setup;
begin
  Client := THTTPClient.Create;
  WebMock := TWebMock.Create;
end;

procedure TResponseBodyTests.TearDown;
begin
  WebMock.Free;
  Client.Free;
end;

procedure TResponseBodyTests.WithBodyFile_GivenContentType_ReturnsStringAsContentType;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('GET', '/')
    .ToRespond
    .WithBodyFile('..\..\FixtureFiles\Video.3gp', 'video/3gpp');

  LResponse := Client.Get(WebMock.URLFor('/'));

  Assert.StartsWith('video/3gpp', LResponse.MimeType);
end;

procedure TResponseBodyTests.WithBodyFile_GivenFilePath_ReturnsFileWithInferredContentType;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('GET', '/')
    .ToRespond
    .WithBodyFile('..\..\FixtureFiles\HelloWebMocks.html');

  LResponse := Client.Get(WebMock.URLFor('/'));

  Assert.IsMatch('<h1>Hello WebMocks</h1>', LResponse.ContentAsString);
  Assert.StartsWith('text/html', LResponse.MimeType);
end;

procedure TResponseBodyTests.WithBody_GivenContentType_ReturnsStringAsContentType;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('GET', '/')
    .ToRespond
    .WithBody('{ "key": "value" }', 'application/json');

  LResponse := Client.Get(WebMock.URLFor('/'));

  Assert.AreEqual('{ "key": "value" }', LResponse.ContentAsString);
  Assert.AreEqual('application/json', LResponse.MimeType);
end;

procedure TResponseBodyTests.WithBody_GivenString_ReturnsStringAsPlainText;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('GET', '/').ToRespond.WithBody('Hello');

  LResponse := Client.Get(WebMock.URLFor('/'));

  Assert.AreEqual('Hello', LResponse.ContentAsString);
  Assert.AreEqual('text/plain; charset=utf-8', LResponse.MimeType);
end;

initialization
  TDUnitX.RegisterTestFixture(TResponseBodyTests);

end.
