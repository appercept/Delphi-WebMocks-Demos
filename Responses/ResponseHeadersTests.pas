unit ResponseHeadersTests;

interface

uses
  DUnitX.TestFramework,
  System.Net.HttpClient,
  WebMock;

type
  [TestFixture]
  TResponseHeadersTests = class
  private
    Client: THTTPClient;
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure WithHeader_GivenNameAndValue_SetsHeader;
    [Test]
    procedure WithHeader_WhenChained_SetsMultipleHeaders;
    [Test]
    procedure WithHeaders_GivenStrings_SetsMultipleHeaders;
  end;

implementation

uses
  System.Classes,
  WebMock.ResponseStatus;

procedure TResponseHeadersTests.Setup;
begin
  Client := THTTPClient.Create;
  WebMock := TWebMock.Create;
end;

procedure TResponseHeadersTests.TearDown;
begin
  WebMock.Free;
  Client.Free;
end;

procedure TResponseHeadersTests.WithHeaders_GivenStrings_SetsMultipleHeaders;
var
  LHeaders: TStringList;
  LResponse: IHTTPResponse;
begin
  LHeaders := TStringList.Create;
  LHeaders.Values['cache-control'] := 'no-cache';
  LHeaders.Values['last-modified'] := 'Sat, 13 Feb 2021 12:45:26 GMT';
  WebMock.StubRequest('GET', '/resources/1')
    .ToRespond
    .WithHeaders(LHeaders);

  LResponse := Client.Get(WebMock.URLFor('/resources/1'));

  Assert.AreEqual('no-cache', LResponse.HeaderValue['cache-control']);
  Assert.AreEqual('Sat, 13 Feb 2021 12:45:26 GMT',
                  LResponse.HeaderValue['last-modified']);

  LHeaders.Free;
end;

procedure TResponseHeadersTests.WithHeader_GivenNameAndValue_SetsHeader;
var
  LResponse: IHTTPResponse;
  LPostContent: TStream;
begin
  LPostContent := TMemoryStream.Create;
  WebMock.StubRequest('POST', '/resources')
    .ToRespond
    .WithStatus(Created)
    .WithHeader('location', 'http://example.com/resources/1');

  LResponse := Client.Post(WebMock.URLFor('/resources'), LPostContent);

  Assert.AreEqual('http://example.com/resources/1',
                  LResponse.HeaderValue['location']);

  LPostContent.Free;
end;

procedure TResponseHeadersTests.WithHeader_WhenChained_SetsMultipleHeaders;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('GET', '/resources/1')
    .ToRespond
    .WithHeader('cache-control', 'no-cache')
    .WithHeader('last-modified', 'Sat, 13 Feb 2021 12:45:26 GMT');

  LResponse := Client.Get(WebMock.URLFor('/resources/1'));

  Assert.AreEqual('no-cache', LResponse.HeaderValue['cache-control']);
  Assert.AreEqual('Sat, 13 Feb 2021 12:45:26 GMT',
                  LResponse.HeaderValue['last-modified']);
end;

initialization
  TDUnitX.RegisterTestFixture(TResponseHeadersTests);

end.
